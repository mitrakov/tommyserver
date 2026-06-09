package com.mitrakoff.self.tommykcal

import com.mitrakoff.self.auth.Id
import io.circe.generic.semiauto.{deriveDecoder, deriveEncoder}
import io.circe.{Decoder, Encoder}
import java.time.LocalDate

// === Meal ===
case class Product(id: Option[Id], name: String, description: String, kcalPer100g: Int, defaultWeight: Int)
case class Meal(id: Option[Id], date: LocalDate, name: String, kcalTotal: Int, comment: Option[String])
case class AddMeal(date: LocalDate, productId: Id, weight: Int, comment: Option[String])

// === CODECS ===
object Product:
  given Encoder[Product] = deriveEncoder

object Meal:
  given Encoder[Meal] = deriveEncoder

object AddMeal:
  given Decoder[AddMeal] = deriveDecoder
