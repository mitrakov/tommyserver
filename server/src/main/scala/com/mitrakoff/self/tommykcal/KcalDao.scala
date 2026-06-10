package com.mitrakoff.self.tommykcal

import com.mitrakoff.self.Db
import com.mitrakoff.self.auth.Id
import doobie.syntax.all.toSqlInterpolator
import java.time.LocalDate

/*
CREATE TABLE kcal."user" (
  user_id serial PRIMARY KEY NOT NULL,
  login varchar(128) UNIQUE NOT NULL,
  hash varchar(255) NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE TABLE kcal.product (
  product_id serial PRIMARY KEY NOT NULL,
  "name" varchar(64) UNIQUE NOT NULL,
  description varchar(255) NULL,
  kcal_per_100 int NOT NULL,
  default_weight_g int NOT NULL DEFAULT 100,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE TABLE kcal.main (
  id bigserial PRIMARY KEY NOT NULL,
  "date" date DEFAULT now() NOT NULL,
  user_id int NOT NULL,
  product_id int NOT NULL,
  weight_g int NOT NULL,
  "comment" varchar(255) NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT product_id_fkey FOREIGN KEY (product_id) REFERENCES kcal.product(product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT user_id_fkey    FOREIGN KEY (user_id)    REFERENCES kcal."user"(user_id)     ON DELETE RESTRICT ON UPDATE CASCADE
);
*/

class KcalDao[F[_]](db: Db[F]):
  def fetchProducts: F[List[Product]] =
    import doobie.implicits.autoDerivedRead
    db.run(sql"""SELECT product_id, name, description, kcal_per_100, default_weight_g FROM kcal.product""".query[Product].to[List])
  
  def fetchAllForDate(userId: Id, date: LocalDate): F[List[Meal]] =
    import doobie.implicits.javatimedrivernative.JavaLocalDateMeta
    import doobie.implicits.autoDerivedRead
    db.run(sql"""SELECT id, date, p.name, p.kcal_per_100 * weight_g / 100, comment
                 FROM kcal.main
                 INNER JOIN kcal.product AS p USING(product_id)
                 WHERE date = $date AND user_id = $userId ORDER BY id;""".query[Meal].to[List]
    )

  def insert(date: LocalDate, userId: Id, productId: Id, weight: Int, comment: Option[String]): F[Int] =
    import doobie.implicits.javatimedrivernative.JavaLocalDateMeta
    db.run(
      sql"""INSERT INTO kcal.main (date, user_id, product_id, weight_g, comment)
                   VALUES ($date, $userId, $productId, $weight, $comment);""".update.run
    )

  def deleteById(id: Id): F[Int] =
    db.run(sql"""DELETE FROM kcal.main WHERE id = $id""".update.run)
