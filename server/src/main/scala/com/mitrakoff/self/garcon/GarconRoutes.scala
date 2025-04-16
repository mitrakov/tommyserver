package com.mitrakoff.self.garcon

import cats.{Applicative, Monad}
import cats.data.{Kleisli, OptionT}
import com.mitrakoff.self.{AuthService, Id}
import org.http4s.circe.jsonEncoderOf
import org.http4s.{AuthedRoutes, EntityEncoder, HttpRoutes, Request}
import org.http4s.dsl.Http4sDsl
import org.http4s.headers.Authorization
import org.http4s.server.AuthMiddleware

class GarconRoutes[F[_]: Monad](authService: AuthService[F], garconService: GarconService[F]) extends Http4sDsl[F]:
  private final val garcon = "garcon"
  private object PageMatcher extends QueryParamDecoderMatcher[Int]("page")

  val routes: HttpRoutes[F] =
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
      case GET -> Root / `garcon` / "words" :? PageMatcher(page) as userId =>
        given EntityEncoder[F, List[Word]] = jsonEncoderOf
        Ok(garconService.getNext(userId, page))
    })
