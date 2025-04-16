package com.mitrakoff.self.garcon

import io.circe.Encoder
import io.circe.generic.semiauto.deriveEncoder

case class Word(word: String, translations: String)

object Word:
  given Encoder[Word] = deriveEncoder
