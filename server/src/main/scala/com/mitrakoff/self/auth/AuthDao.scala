package com.mitrakoff.self.auth

import com.mitrakoff.self.Db
import doobie.implicits.toSqlInterpolator

class AuthDao[F[_]](db: Db[F]):
  case class User(id: Int, login: String, secret: String)

  def getAuth(login: String): F[Option[User]] =
    import doobie.implicits.autoDerivedRead
    db.run(sql"""SELECT * FROM auth.user WHERE login = $login""".query[User].option)
