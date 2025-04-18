package com.mitrakoff.self.auth

import cats.effect.Concurrent
import org.http4s.circe.jsonOf
import org.http4s.dsl.Http4sDsl
import org.http4s.*

class AuthRoutes[F[_]: Concurrent](authService: AuthService[F]) extends Http4sDsl[F]:
  val routes: HttpRoutes[F] =
    HttpRoutes.of {
      case req@POST -> Root / "auth" =>
        import cats.implicits.{toFlatMapOps, toFunctorOps, catsSyntaxApplicativeId}
        given EntityDecoder[F, AuthData] = jsonOf

        for {
          request <- req.as[AuthData]
          either <- authService.auth(request.login, request.hash)
          response <- either match
            case Right(token) => Ok(token)
            case Left(err) => Response(status = Status.Unauthorized).pure[F]
        } yield response
    }
