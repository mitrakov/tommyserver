package com.mitrakoff.self.garcon

import com.mitrakoff.self.{Db, Id}
import doobie.implicits.toSqlInterpolator

class GarconDao[F[_]](db: Db[F]):
  case class Word(word: String, translations: String)

  def fetchNext(userId: Id, page: Int): F[List[Word]] =
    import doobie.implicits.derived
    db.run(sql"""SELECT * FROM wordlist WHERE userId=$userId;""".query[Word].to[List])
