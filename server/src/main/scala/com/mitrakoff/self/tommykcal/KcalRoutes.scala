package com.mitrakoff.self.tommykcal

import cats.Applicative
import cats.data.{Kleisli, OptionT}
import cats.effect.Concurrent
import com.mitrakoff.self.auth.{AuthService, Id}
import org.http4s.circe.{jsonEncoderOf, jsonOf}
import org.http4s.dsl.Http4sDsl
import org.http4s.headers.Authorization
import org.http4s.server.AuthMiddleware
import org.http4s.{AuthedRoutes, EntityDecoder, EntityEncoder, HttpRoutes, Request}
import java.time.LocalDate
import scala.util.{Failure, Success, Try}

class KcalRoutes[F[_]: Concurrent](authService: AuthService[F], kcalService: KcalService[F]) extends Http4sDsl[F]:
  private final val kcal: String = "kcal"

  val routes: HttpRoutes[F] =
    import cats.implicits.{toFlatMapOps, toFunctorOps}
    import org.http4s.syntax.header.http4sHeaderSyntax

    val onFailure: AuthedRoutes[String, F] = Kleisli(req => OptionT.liftF(Forbidden(req.context)))
    val authUser: Kleisli[F, Request[F], Either[String, Id]] = Kleisli { request =>
      val either = for {
        token <- request.headers.get[Authorization].map(_.value.toLowerCase.replace("bearer ", ""))
                 .toRight(s"Authorization header not found")
        result <- authService.isTokenValid(token)
      } yield result
      implicitly[Applicative[F]].pure(either)
    }

    AuthMiddleware(authUser, onFailure).apply(AuthedRoutes.of {
      // curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/kcal/products
      case GET -> Root / `kcal` / "products" as userId =>
        given EntityEncoder[F, List[Product]] = jsonEncoderOf
        Ok(kcalService.getProducts)

      // curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/kcal/2025-09-20
      case GET -> Root / `kcal` / date as userId =>
        given EntityEncoder[F, List[Meal]] = jsonEncoderOf
        Try(LocalDate.parse(date)) match
          case Failure(error) => BadRequest(s"Cannot parse date: $date (${error.getMessage})")
          case Success(parsed) => for {
            chronicle <- kcalService.getAllForDate(userId, parsed)
            response <- Ok(chronicle)
          } yield response

      // curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/kcal -d '{"date":"2025-09-20", "productId":5, "weight":250}'
      case req@POST -> Root / `kcal` as userId =>
        given EntityDecoder[F, AddMeal] = jsonOf
        for {
          request <- req.req.as[AddMeal]
          rows <- kcalService.add(userId, request)
          response <- Ok(s"$rows row(s) added")
        } yield response

      // curl -X DELETE -H "Authorization: bearer XXX" http://mitrakoff.com:9090/kcal/5
      case DELETE -> Root / `kcal` / LongVar(id) as userId =>
        for {
          rows <- kcalService.delete(id)
          response <- Ok(s"$rows row(s) deleted")
        } yield response
    })
