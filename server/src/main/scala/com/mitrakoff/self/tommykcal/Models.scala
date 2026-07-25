package com.mitrakoff.self.tommykcal

import com.mitrakoff.self.auth.Id
import io.circe.generic.semiauto.{deriveCodec, deriveDecoder, deriveEncoder}
import io.circe.{Codec, Decoder, Encoder}
import java.time.LocalDate

// === Meal ===
case class Product(id: Option[Id], name: String, description: Option[String], kcalPer100g: Int, defaultWeight: Option[Int])
case class Meal(id: Id, date: LocalDate, name: String, kcalPer100g: Int, weight: Int, comment: Option[String])
case class AddMeal(date: LocalDate, productId: Id, weight: Int, comment: Option[String])

// === CODECS ===
object Product:
  given Codec[Product] = deriveCodec

object Meal:
  given Encoder[Meal] = deriveEncoder

object AddMeal:
  given Decoder[AddMeal] = deriveDecoder
