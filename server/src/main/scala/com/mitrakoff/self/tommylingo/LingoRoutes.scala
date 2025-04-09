package com.mitrakoff.self.tommylingo

import cats.effect.Async
import cats.implicits.{toFlatMapOps, catsSyntaxApplyOps, catsSyntaxApplicativeId}
import org.http4s.Response
import org.http4s.{EntityDecoder, EntityEncoder, HttpRoutes}
import org.http4s.dsl.Http4sDsl
import org.http4s.scalaxml.{xmlDecoder, xmlEncoder}

/// curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/lingo/all/en-GB
/// curl -H "Authorization: bearer XXX" http://mitrakoff.com:9090/lingo/key/en-GB/flexible
class LingoRoutes[F[_]: Async](service: LingoService[F]) extends Http4sDsl[F]:
  given EntityDecoder[F, DictKey] = xmlDecoder map { elem =>
    val langCode = (elem \ "langCode").text.trim
    val key = (elem \ "key").text.trim
    DictKey(1, langCode, key)
  }

  given EntityDecoder[F, Dict] = xmlDecoder map { elem =>
    // note: do NOT reuse other decoders! "xmlDecoder.map" may be called only once!
    val langCode = (elem \ "langCode").text.trim
    val key = (elem \ "key").text.trim
    val translation = (elem \ "translation").text.trim
    Dict(DictKey(1, langCode, key), translation)
  }

  @deprecated
  given keysEncoder: EntityEncoder[F, List[String]] =
    xmlEncoder contramap { list => <keys>{list map(s => {<key>{s}</key>})}</keys> }

  given translationsEncoderList: EntityEncoder[F, List[(String, String, Option[String])]] =
    xmlEncoder contramap { list => <result>{list map {
      case (k, v, Some(c)) => <item key={k} conjugation={c}>{v}</item>
      case (k, v, None)    => <item key={k}>{v}</item>
    }}</result> }

  given translationsEncoder: EntityEncoder[F, (String, String, Option[String])] =
    xmlEncoder contramap {
      case (k, v, Some(c)) => <item key={k} conjugation={c}>{v}</item>
      case (k, v, None)    => <item key={k}>{v}</item>
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
      req.as[Dict] flatMap (service.upsert(_) *> Ok(<result>ok</result>))
    case req @ DELETE -> Root / "lingo" =>
      req.as[DictKey] flatMap (service.remove(_) *> Ok(<result>ok</result>))
  }
