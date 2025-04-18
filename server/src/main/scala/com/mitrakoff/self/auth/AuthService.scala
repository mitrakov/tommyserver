package com.mitrakoff.self.auth

import cats.Functor

type Id = Int

class AuthService[F[_]: Functor](dao: AuthDao[F]) {
  def auth(login: String, secret: String): F[Either[String, String]] =
    import cats.implicits.toFunctorOps
    dao.getAuth(login, secret) map {
      case Some(user) =>
        // TODO: add to cache
        // TODO: generate token
        Right("555")
      case None => Left("Invalid Auth")
    }

  def isTokenValid(token: String): Either[String, Id] =
    // TODO WTF, bro? replace with https://pastebin.com/zUjAgTdw
    Either.cond(token == "555", 1, "Invalid token")
}
