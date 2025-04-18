package com.mitrakoff.self.auth

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator

class AuthDao[F[_]](db: Db[F]):
  def getAuth(login: String, secret: String): F[Option[User]] =
    import doobie.implicits.derived
    db.run(sql"""SELECT * FROM auth.user WHERE login = $login""".query[User].option)

  case class User(id: Int, login: String, secret: String)
