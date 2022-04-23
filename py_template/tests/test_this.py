#!/usr/bin/env python
import unittest


class TestBlah(unittest.TestCase):
    
    def setUp(self) -> None:
        return super().setUp()
    
    def test_check(self):
        self.assertEqual(1, 0 + 1)
    
    def tearDown(self) -> None:
        return super().tearDown()


if __name__ == "__main__":
    unittest.main()
