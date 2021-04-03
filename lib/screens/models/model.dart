import 'package:flutter/material.dart';

class Product {
  final String image, title, description;
  final double coins;
  final int price, size, id;
  final Color color;

  Product({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
    this.coins
  });
}

List<Product> products = [
  Product(
      id: 1,
      title: "Beats Headphone",
      size: 12,
      description: 'The drivers in the speakers are designed to deliver deep bass and ultra-clear highs and midrange. These urBeats headphones play your music with precision on every note and beat, a specialty of urBeats audio quality. The urBeats headphones come with stylish and matching cords and earbuds.',
      image: "Assets/product1.jpg",
      coins:2000,
      color: Color(0xFF3D82AE)),
  Product(
      id: 2,
      title: "Earphone",
      size: 8,
      description: 'Earphones are a small piece of equipment which you wear over or inside your ears so that you can listen to music, the radio, or your phone without anyone else hearing. 2. countable noun. An earphone is the part of a telephone receiver or other device that you hold up to your ear or put into your ear.',
      coins:900,
      image: "Assets/product2.jpg",
      color: Color(0xFFD3A984)),
  Product(
      id: 3,
      title: "Smart Clock",
      size: 10,
      description: 'Smart Clock with the Google Assistant does more than just tell you the time and wake you up. Designed to reduce smartphone screen-time at night, it can help you unwind and sleep better. It can also run your smart home, play your favorite music across your home, manage your schedule, and much more.',
      coins:4990,
      image: "Assets/product3.jpg",
      color: Color(0xFF989493)),
  Product(
      id: 4,
      title: "Ola Watch",
      size: 11,
      description: 'A smartwatch is a digital watch that provides many other features besides timekeeping. ... Like a smartphone, a smartwatch has a touchscreen display, which allows you to perform actions by tapping or swiping on the screen. Modern smartwatches include several apps, similar to apps for smartphones and tablets.',
      coins:10999,
      image: "Assets/product4.jpg",
      color: Color(0xFFE6B398)),
  Product(
      id: 5,
      title: "Alexa",
      size: 12,
      description: 'Alexa is a virtual assistant developed by Amazon for its Echo and Echo Dot computing devices, which range in price from \$50-200 USD. Alexa s capabilities are similar to those of other virtual assistants such as Apple Siri, Microsoft Cortana, Google Assistant, and Samsung Bixby.',
      coins:5990,
      image: "Assets/product5.png",
      color: Color(0xFFFB7883)),
  Product(
    id: 6,
    title: "Laptop Bag",
    size: 12,
    description: 'A laptop backpack is a backpack with a special compartment in which you can store your laptop. ... A backpack has multiple compartments for your computer accessories. Because of the shoulder straps, a backpack is ideal if you have to walk, cycle or use public transport.',
    coins:890,
    image: "Assets/product6.jpg",
    color: Color(0xFFAEAEAE),
  ),
];

String dummyText ='hello';