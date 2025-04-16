package com.mitrakoff.self

type Id = Int

class AuthService[F[_]] {
  def isTokenValid(token: String): Either[String, Id] = {
    // TODO WTF, bro? replace with https://pastebin.com/zUjAgTdw
    Either.cond(token == "555", 1, "Invalid Auth")
  }
}
