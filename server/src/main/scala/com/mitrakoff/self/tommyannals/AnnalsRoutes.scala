package com.mitrakoff.self.tommyannals

import cats.data.{Kleisli, OptionT}
import cats.effect.Concurrent
import cats.Applicative
import com.mitrakoff.self.auth.{AuthService, Id}
import org.http4s.circe.{jsonEncoderOf, jsonOf}
import org.http4s.dsl.Http4sDsl
import org.http4s.headers.Authorization
import org.http4s.server.AuthMiddleware
import org.http4s.{AuthedRoutes, EntityDecoder, EntityEncoder, HttpRoutes, Request}
import java.time.LocalDate
import scala.util.{Failure, Success, Try}

class AnnalsRoutes[F[_]: Concurrent](authService: AuthService[F], annalsService: AnnalsService[F]) extends Http4sDsl[F]:
  private final val annals: String = "annals"

  val routes: HttpRoutes[F] =
    import cats.implicits.{toFlatMapOps, toFunctorOps}
    import org.http4s.syntax.header.http4sHeaderSyntax

    val onFailure: AuthedRoutes[String, F] = Kleisli(req => OptionT.liftF(Forbidden(req.context)))
    val authUser: Kleisli[F, Request[F], Either[String, Id]] = Kleisli { request =>
      val either = for {
        token <- request.headers.get[Authorization].map(_.value.toLowerCase.replace("bearer ", "")).toRight(s"Authorization header not found")
        result <- authService.isTokenValid(token)
      } yield result
      implicitly[Applicative[F]].pure(either)
    }

    AuthMiddleware(authUser, onFailure).apply(AuthedRoutes.of {
      // curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/annals/schema
      case GET -> Root / `annals` / "schema" as userId =>
        given EntityEncoder[F, List[SchemaResponse]] = jsonEncoderOf
        for {
          schema   <- annalsService.getSchema(userId)
          response <- Ok(schema)
        } yield response

      // curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/annals/2025-09-20
      case GET -> Root / `annals` / date as userId =>
        given EntityEncoder[F, List[Chronicle]] = jsonEncoderOf
        Try(LocalDate.parse(date)) match
          case Failure(error) => BadRequest(s"Cannot parse date: $date (${error.getMessage})")
          case Success(parsed) => for {
            chronicle <- annalsService.getAllForDate(userId, parsed)
            response <- Ok(chronicle)
          } yield response

      case req@POST -> Root / `annals` as userId =>
        given EntityDecoder[F, Chronicle] = jsonOf
        for {
          request <- req.req.as[Chronicle]
          rows <- annalsService.add(userId, request)
          response <- Ok(s"$rows row(s) added")
        } yield response

      case DELETE -> Root / `annals` / LongVar(id) as userId =>
        for {
          rows <- annalsService.delete(id)
          response <- Ok(s"$rows row(s) deleted")
        } yield response
    })
