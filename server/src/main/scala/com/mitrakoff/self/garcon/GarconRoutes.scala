package com.mitrakoff.self.garcon

import cats.Monad
import com.mitrakoff.self.auth.AuthService
import org.http4s.circe.jsonEncoderOf
import org.http4s.dsl.Http4sDsl
import org.http4s.*

// curl http: //mitrakoff.com:9090/garcon/words?page=0 -H "Authorization: bearer 555"
class GarconRoutes[F[_]: Monad](authService: AuthService[F], garconService: GarconService[F]) extends Http4sDsl[F]:
  private final val garcon = "garcon"
  private object PageMatcher extends QueryParamDecoderMatcher[Int]("page")

  val routes: HttpRoutes[F] =
    authService.jwtMiddleware(AuthedRoutes.of {
      case GET -> Root / `garcon` / "words" :? PageMatcher(page) as userId =>
        given EntityEncoder[F, List[Word]] = jsonEncoderOf
        Ok(garconService.getNext(userId, page))
    })
