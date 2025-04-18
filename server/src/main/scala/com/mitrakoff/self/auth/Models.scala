package com.mitrakoff.self.auth

import io.circe.{Codec, Decoder}
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder}

case class AuthData(login: String, hash: String)
case class JwtTokenPayload(userId: Id)

object AuthData:
  given Decoder[AuthData] = deriveDecoder

object JwtTokenPayload:
  given Codec[JwtTokenPayload] = deriveCodec
