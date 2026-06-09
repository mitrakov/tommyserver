package com.mitrakoff.self.tommykcal

import com.mitrakoff.self.auth.Id
import java.time.LocalDate

class KcalService[F[_]](dao: KcalDao[F]):
  def getAllForDate(userId: Id, date: LocalDate): F[List[Meal]] =
    dao.fetchAllForDate(userId, date)

  def add(userId: Id, m: AddMeal): F[Int] =
    dao.insert(m.date, userId, m.productId, m.weight, m.comment)

  def delete(id: Id): F[Int] =
    dao.deleteById(id)
