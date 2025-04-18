package com.mitrakoff.self.auth

import io.circe.Decoder
import io.circe.generic.semiauto.deriveDecoder

case class AuthData(login: String, hash: String)

object AuthData:
  given Decoder[AuthData] = deriveDecoder
