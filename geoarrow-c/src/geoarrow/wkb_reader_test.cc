
#include "geoarrow/wkx_testing.hpp"

#include <gtest/gtest.h>

#define EXPECT_WKB_ROUNDTRIP(tester_, value_) EXPECT_EQ(tester_.AsWKB(value_), value_)

TEST(WBTReaderTest, WKBReaderTestBasic) {
  struct GeoArrowWKBReader reader;
  GeoArrowWKBReaderInit(&reader);
  GeoArrowWKBReaderReset(&reader);
}

TEST(WKBReaderTest, WKBReaderTestPoint) {
  WKXTester tester;

  std::basic_string<uint8_t> point({0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
                                    0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00,
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40});

  EXPECT_WKB_ROUNDTRIP(tester, point);
  EXPECT_EQ(tester.AsWKT(point), "POINT (30 10)");
}

TEST(WKBReaderTest, WKBReaderTestPointZM) {
  WKXTester tester;

  std::basic_string<uint8_t> point_z({0x01, 0xe9, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0xf0, 0x3f, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x08, 0x40});

  std::basic_string<uint8_t> point_m({0x01, 0xd1, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0xf0, 0x3f, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x08, 0x40});

  std::basic_string<uint8_t> point_zm(
      {0x01, 0xb9, 0x0b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x3f,
       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
       0x00, 0x08, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x40});

  EXPECT_EQ(tester.AsWKT(point_z), "POINT Z (1 2 3)");
  EXPECT_EQ(tester.AsWKT(point_m), "POINT M (1 2 3)");
  EXPECT_EQ(tester.AsWKT(point_zm), "POINT ZM (1 2 3 4)");
}

TEST(WKBReaderTest, WKBReaderTestPointInvalid) {
  WKXTester tester;

  std::basic_string<uint8_t> short_point1({});

  std::basic_string<uint8_t> short_point2({0x01, 0x01, 0x00, 0x00});

  std::basic_string<uint8_t> short_point3({0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
                                           0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00,
                                           0x00, 0x00, 0x00, 0x00, 0x00, 0x24});

  std::basic_string<uint8_t> bad_point({0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00,
                                        0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00,
                                        0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40});

  EXPECT_THROW(tester.AsWKB(short_point1), WKXTestException);
  EXPECT_EQ(tester.LastErrorMessage(),
            "Expected endian byte but found end of buffer at byte 0");
  EXPECT_THROW(tester.AsWKB(short_point2), WKXTestException);
  EXPECT_EQ(tester.LastErrorMessage(),
            "Expected uint32 but found end of buffer at byte 1");
  EXPECT_THROW(tester.AsWKB(short_point3), WKXTestException);
  EXPECT_EQ(tester.LastErrorMessage(),
            "Expected coordinate sequence of 1 coords (16 bytes) but found 15 bytes "
            "remaining at byte 5");

  EXPECT_THROW(tester.AsWKB(bad_point), WKXTestException);
  EXPECT_EQ(tester.LastErrorMessage(),
            "Expected valid geometry type code but found 257 at byte 1");
}

TEST(WKBReaderTest, WKBReaderTestPointBigEndian) {
  WKXTester tester;

  std::basic_string<uint8_t> point({0x00, 0x00, 0x00, 0x00, 0x01, 0x40, 0x3e,
                                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40,
                                    0x24, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00});

  EXPECT_EQ(tester.AsWKT(point), "POINT (30 10)");
}

TEST(WKBReaderTest, WKBReaderTestPointEWKB) {
  WKXTester tester;

  std::basic_string<uint8_t> point_z({0x01, 0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x00, 0x40});

  std::basic_string<uint8_t> point_m({0x01, 0x01, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00,
                                      0x00, 0x00, 0x00, 0x00, 0x40});

  std::basic_string<uint8_t> point_zm(
      {0x01, 0x01, 0x00, 0x00, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x40,
       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
       0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0x3f});

  // These two have embedded SRID values (which the this parser understands but
  // skips since there's no place to put that information)
  std::basic_string<uint8_t> point_s(
      {0x01, 0x01, 0x00, 0x00, 0x20, 0xc7, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
       0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40});

  std::basic_string<uint8_t> point_zms(
      {0x01, 0x01, 0x00, 0x00, 0xe0, 0xe6, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
       0x00, 0x3e, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00,
       0x00, 0x00, 0x00, 0x28, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2c, 0x40});

  EXPECT_EQ(tester.AsWKT(point_z), "POINT Z (30 10 2)");
  EXPECT_EQ(tester.AsWKT(point_m), "POINT M (30 10 2)");
  EXPECT_EQ(tester.AsWKT(point_zm), "POINT ZM (30 10 2 1)");
  EXPECT_EQ(tester.AsWKT(point_s), "POINT (30 10)");
  EXPECT_EQ(tester.AsWKT(point_zms), "POINT ZM (30 10 12 14)");
}

TEST(WKBReaderTest, WKBReaderTestLinestring) {
  WKXTester tester;

  EXPECT_WKB_ROUNDTRIP(
      tester, std::basic_string<uint8_t>(
                  {0x01, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
                   0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
                   0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28, 0x40,
                   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x45, 0x40}));
}

TEST(WKBReaderTest, WKBReaderTestPolygon) {
  WKXTester tester;

  EXPECT_WKB_ROUNDTRIP(
      tester,
      std::basic_string<uint8_t>(
          {0x01, 0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x41, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x46, 0x40, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x80, 0x46, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2e,
           0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x40, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x80, 0x41, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x24, 0x40, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34,
           0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x80, 0x41, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x41, 0x40, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x34, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x40, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x3e, 0x40}));
}

TEST(WKBReaderTest, WKBReaderTestCollection) {
  WKXTester tester;

  EXPECT_WKB_ROUNDTRIP(
      tester, std::basic_string<uint8_t>(
                  {0x01, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00,
                   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00,
                   0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00,
                   0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
                   0x00, 0x3e, 0x40, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                   0x00, 0x00, 0x34, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x40,
                   0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e,
                   0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40}));
}

TEST(WKBReaderTest, WKBReaderTestNestedCollection) {
  WKXTester tester;

  EXPECT_WKB_ROUNDTRIP(
      tester,
      std::basic_string<uint8_t>(
          {0x01, 0x07, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x24, 0x40, 0x01, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x40, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x34, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24,
           0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x01, 0x03, 0x00, 0x00,
           0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x34, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
           0x46, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x46, 0x40, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x3e, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x01, 0x07, 0x00, 0x00, 0x00,
           0x03, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x01,
           0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x34, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x34,
           0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x44, 0x40, 0x01, 0x03, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
           0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x34, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x46, 0x40, 0x00, 0x00, 0x00,
           0x00, 0x00, 0x80, 0x46, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x40,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x44, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
           0x00, 0x44, 0x40, 0x01, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
           0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x40, 0x00,
           0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x40}));
}

TEST(WKBReaderTest, WKTReaderTestManyCoordinates) {
  // The reader uses an internal coordinate buffer of 3072 ordinates; however,
  // none of the above tests have enough coordinates to run into a situation
  // where it must be flushed.

  // Make a big linestring
  std::stringstream ss;
  ss << "LINESTRING (0 1";
  for (int i = 1; i < 1537; i++) {
    ss << ", " << i << " " << (i + 1);
  }
  ss << ")";

  WKXTester tester;
  std::basic_string<uint8_t> big_linestring_wkb = tester.AsWKB(ss.str());
  EXPECT_WKB_ROUNDTRIP(tester, big_linestring_wkb);
}
