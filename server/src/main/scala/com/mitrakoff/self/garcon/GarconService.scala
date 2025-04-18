package com.mitrakoff.self.garcon

import cats.Functor
import com.mitrakoff.self.auth.Id

class GarconService[F[_]: Functor](dao: GarconDao[F]):
  def getNext(userId: Id, page: Int): F[List[Word]] =
    import cats.implicits.toFunctorOps
    dao.fetchNext(userId, page).map(_.map(w => Word(w.word, w.translations)))
