package com.mitrakoff.self.tommykcal

import com.mitrakoff.self.auth.Id
import java.time.LocalDate

class KcalService[F[_]](dao: KcalDao[F]):
  def getProducts: F[List[Product]] =
    dao.fetchProducts

  def getAllForDate(userId: Id, date: LocalDate): F[List[Meal]] =
    dao.fetchAllForDate(userId, date)

  def addMeal(userId: Id, m: AddMeal): F[Int] =
    dao.insertMeal(m.date, userId, m.productId, m.weight, m.comment)

  def addProduct(userId: Id, p: Product): F[Int] =
    dao.insertProduct(p)

  def delete(id: Id): F[Int] =
    dao.deleteById(id)
