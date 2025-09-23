package com.mitrakoff.self.auth

import cats.MonadThrow
import dev.profunktor.auth.JwtAuthMiddleware
import dev.profunktor.auth.jwt.{JwtAuth, JwtToken}
import io.circe.parser.*
import org.http4s.server.AuthMiddleware
import pdi.jwt.{JwtAlgorithm, JwtCirce, JwtClaim}

import java.time.Instant
import java.time.temporal.ChronoUnit.DAYS

type Id = Long

class AuthService[F[_]: MonadThrow](dao: AuthDao[F]):
  private val secretKey = sys.env.getOrElse("SECRET_KEY", throw new IllegalStateException("Please provide SECRET_KEY env variable"))
  private val jwtAlgorithm = JwtAlgorithm.HS512

  def auth(login: String, secret: String): F[Either[String, String]] =
    import cats.implicits.toFunctorOps
    dao.getAuth(login) map {
      case Some(user) if user.secret == secret =>
        // TODO: encode in Circe
        val now = Instant.now
        val claim = JwtClaim(s"""{"userId": ${user.id}""", expiration = Some(now.plus(1, DAYS).getEpochSecond), issuedAt = Some(now.getEpochSecond))
        Right(JwtCirce.encode(claim, secretKey, jwtAlgorithm))
      case _ => Left("Invalid Auth")
    }

  def isTokenValid(token: String): Either[String, Id] =
    // TODO WTF, bro? replace with https://pastebin.com/zUjAgTdw
    Either.cond(token == "555", 1, "Invalid token")

  private val authenticate: JwtToken => JwtClaim => F[Option[Id]] =
    import cats.implicits.catsSyntaxApplicativeId
    token => claim => decode[JwtTokenPayload](claim.content) match
      case Right(payload) => Some(payload.userId).pure[F]
      case Left(_) => None.pure[F]

  val jwtMiddleware: AuthMiddleware[F, Id] = JwtAuthMiddleware(JwtAuth.hmac(secretKey.toArray, jwtAlgorithm), authenticate)
