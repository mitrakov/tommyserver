package com.mitrakoff.self.tommylingo

import cats.effect.Async
import cats.implicits.{toFlatMapOps, catsSyntaxApplyOps, catsSyntaxApplicativeId}
import org.http4s.Response
import org.http4s.{EntityDecoder, EntityEncoder, HttpRoutes}
import org.http4s.dsl.Http4sDsl
import org.http4s.scalaxml.{xmlDecoder, xmlEncoder}

/// curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/lingo/all/en-GB
/// curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/lingo/key/en-GB/flexible
/// curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/lingo -X DELETE \
///            -d '<a><langCode>en-GB</langCode><key>flexible</key></a>'
class LingoRoutes[F[_]: Async](service: LingoService[F]) extends Http4sDsl[F]:
  given edKey : EntityDecoder[F, Option[DictKey]] = xmlDecoder.map { elem =>
    Some(DictKey(1, (elem \ "langCode").text.trim, (elem \ "key").text.trim))
  }.handleError(_ => None)

  given edDict : EntityDecoder[F, Option[Dict]] = xmlDecoder.map { elem =>
    // note: do NOT reuse other decoders! "xmlDecoder.map" may be called only once!
    Some(Dict(DictKey(1, (elem \ "langCode").text.trim, (elem \ "key").text.trim), (elem \ "translation").text.trim))
  }.handleError(_ => None)

  @deprecated
  given keysEncoder: EntityEncoder[F, List[String]] =
    xmlEncoder contramap { list => <keys>{list map(s => {<key>{s}</key>})}</keys> }

  given translationsEncoderList: EntityEncoder[F, List[(String, String, Boolean)]] =
    xmlEncoder contramap { list => <result>{list map {
      case (k, v, true)  => <item key={k} hide={"true"}>{v}</item>
      case (k, v, false) => <item key={k}>{v}</item>
    }}</result> }

  given translationsEncoder: EntityEncoder[F, (String, String, Boolean)] =
    xmlEncoder contramap {
      case (k, v, true)  => <item key={k} hide={"true"}>{v}</item>
      case (k, v, false) => <item key={k}>{v}</item>
    }

  val routes: HttpRoutes[F] = HttpRoutes.of {
    case GET -> Root / "lingo" / "all" / langCode =>
      Ok(service.getAll(1, langCode))
    case GET -> Root / "lingo" / "key" / langCode / key =>
      service.getByKey(1, langCode, key) flatMap {
        case Some(x) => Ok(x)
        case None => Response.notFound.pure[F]
      }
    case req @ POST -> Root / "lingo" =>
      req.as[Option[Dict]] flatMap {
        case Some(d) => service.upsert(d) *> Ok(<result>ok</result>)
        case None    => BadRequest(<result>parse error</result>)
      }
    case req @ DELETE -> Root / "lingo" =>
      req.as[Option[DictKey]] flatMap {
        case Some(k) => service.softDelete(k) *> Ok(<result>ok</result>)
        case None    => BadRequest(<result>parse error</result>)
      }
    case req @ DELETE -> Root / "lingo" / "hard" =>
      req.as[Option[DictKey]] flatMap {
        case Some(k) => service.remove(k) *> Ok(<result>ok</result>)
        case None    => BadRequest(<result>parse error</result>)
      }
  }
