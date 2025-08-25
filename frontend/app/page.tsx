"use client"
import { useState } from "react"

function Home () {

  const devices = [
    { name: "Wireless Earbuds", price: "400", image: "/earbuds.png" },
    { name: "Smart Watch", price: "700", image: "/smartwatch.png" },
    { name: "4K Monitor", price: "8000", image: "/4k.png" },
  ]

  const features = [
    { title: "Secure Paymnent", description: "All transactions are encrypted and secure with multiple payment options.", icon: "/lock.png" },
    { title: "Fast Delivery", description: "We ship nationwide with delivery in 2-3 business days for most items." , icon: "/cargo-truck.png"},
    { title: "24/7 Support", description: "Our customer service team is available around the clock to assist you.", icon: "/customer-support.png"},
  ]

  const[showItems, setShowItems] = useState(false);

  return (
    <div className="bg-gray-100 min-h-screen">
      {/* Navigation */}
      <nav className="bg-white shadow-md">
        <div className="flex justify-between items-center container mx-auto px-4 py-3">
          {/* logo */}
          <div className="flex gap-2 items-center">
            <img src="/logo.png" alt="logo" width={60} height={60} />
            <p className="text-blue-700 font-bold text-2xl">ElectroHub</p>
          </div>

          {/* desktop menu */}
          <div className="hidden md:flex bg-white rounded-md items-center p-4 gap-6">
            <a href="#" className="text-gray-700 hover:text-blue-600 font-medium">Home</a>
            <a href="#about" className="text-gray-700 hover:text-blue-600 font-medium">About Us</a>
            <a href="#features" className="text-gray-700 hover:text-blue-600 font-medium">Features</a>
            <a href="#contact" className="text-gray-700 hover:text-blue-600 font-medium">Contact Us</a>
            <a href="#" className="bg-blue-600 text-white px-4 py-2 rounded-md font-medium">Login</a>
          </div>

          {/* md menu */}
          <div className="md:hidden">
            <button onClick={() => setShowItems(!showItems)}>
              <img src="/dial-pad.png" alt="phone" width={40} />
            </button>
          </div>
        </div>
        {showItems && (
          <div className="flex flex-col items-center py-4 gap-4 bg-gray-50 border-t">
            <a href="#" className="text-gray-700 hover:text-blue-600 font-medium">Home</a>
            <a href="#about" className="text-gray-700 hover:text-blue-600 font-medium">About Us</a>
            <a href="#features" className="text-gray-700 hover:text-blue-600 font-medium">Features</a>
            <a href="#contact" className="text-gray-700 hover:text-blue-600 font-medium">Contact Us</a>
            <a href="#" className="bg-blue-600 text-white px-4 py-2 rounded-md font-medium">Login</a>
          </div>
        )}
      </nav>

      {/* hero-section */}
      <section className="bg-gradient-to-r from-blue-500 to-purple-600 text-white py-16">
        <div className="container mx-auto px-4 text-center">
          <h1 className="text-5xl font-bold mb-6">Welcome to ElectroHub</h1>
          <p className="text-xl mb-8 max-w-2xl mx-auto">Your one-stop destination for the latest electronics and gadgets at unbeatable prices.</p>

          {/* buttons */}
          <div className="flex justify-center gap-4">
            <button className="bg-white text-blue-600 px-6 py-3 rounded-md font-semibold text-lg hover:bg-gray-100">
              Shop Now
            </button>
            <button className="bg-transparent border-2 border-white text-white px-6 py-3 rounded-md font-semibold text-lg hover:bg-white hover:text-blue-600">
              View Details
            </button>
          </div>
        </div>
      </section>

      {/* featured Products */}
      <section className="py-12 bg-white">
        <div className="mx-auto px-4 container">
          <h2 className="text-3xl font-bold text-center mb-12">Featured Products</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {devices.map((device, index) => (
              <div className="bg-gray-50 rounded-lg overflow-hidden shadow-md hover:shadow-lg transition-shadow" key={index}>
                <div className="h-56 bg-gray-200 flex items-center justify-center">
                  <span className="text-gray-500"><img src={device.image} alt="images" width={100} height={100} /></span>
                </div>
                <div className="p-6">
                  <h3 className="text-xl font-semibold mb-2">{device.name}</h3>
                  <p className="text-blue-600 font-bold text-lg mb-4">{device.price}</p>
                  {/* cart botton */}
                  <button className="w-full bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700">
                    Add to Cart
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* about-section */}
      <section id="about" className="py-16 bg-gray-50">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">About Us</h2>
          <div className="flex flex-col md:flex-row items-center gap-10">

            {/* about image */}
            <div className="md:w-1/2">
              <div className="h-80 bg-gray-200 rounded-lg flex items-center justify-center">
                <span className="text-gray-500"><img src="/logo.png" alt="logo" width={300} /></span>
              </div>
            </div>

            {/* desc */}
            <div className="md:w-1/2">
              <h3 className="text-2xl font-semibold mb-4">Why Choose ElectroHub?</h3>
              <p className="text-gray-700 mb-6">At ElectroHub, we&apos;re passionate about technology and committed to bringing you the latest electronic devices from trusted
                brands around the world. Since 2020, we&apos;ve been tech enthusiasts with high-quality products at competitive prices.
              </p>
              <ul className="space-y-3">
                <li className="flex items-center">
                  <span className="text-green-300"><img src="/checked.png" alt="logo" width={30} /></span>
                  <span>5+ years of industry experience</span>
                </li>
                <li className="flex items-center">
                  <span className="text-green-300"><img src="/checked.png" alt="logo" width={30} /></span>
                  <span>Authentic products with manufacturer warranty</span>
                </li>
                <li className="flex items-center">
                  <span className="text-green-300"><img src="/checked.png" alt="logo" width={30} /></span>
                  <span>Free shiiping on orders over 15,000</span>
                </li>
                <li className="flex items-center">
                  <span className="text-green-300"><img src="/checked.png" alt="logo" width={30} /></span>
                  <span>30-day money-back guarantee</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* fetures section */}
      <section id="features" className="py-16 bg-white">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">Why Shop With Us?</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <div className="bg-gray-50 p-8 rounded-lg text-center shadow-sm hover:shadow-md transition-shadow" key={index}>
                <div className=""><img src={feature.icon} alt="icon" width={40} /></div>
                <h3 className="text-xl font-semibold mb-4">{feature.title}</h3>
                <p className="text-gray-700">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* contact-section */}
      <section id="contact" className="py-16 bg-gray-50">
        <div className="container mx-auto px-4">
          <h2 className="text-center mb-12 font-bold text-3xl">Contact Us</h2>
          <div className="flex flex-col md:flex-row gap-10">

            {/* form */}
            <div className="md:w-1/2">
              <form className="bg-white p-8 rounded-lg shadow-md" action="https://formspree.io/f/mrblnlaa" method="POST">

                {/* title */}
                <h3 className="text-xl font-semibold mb-6">Send us a message</h3>

                {/* name label */}
                <div className="mb-4">
                  <label className="block text-gray-700 mb-2" htmlFor="name">Name</label>
                  <input type="text" name="name" id="name" className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Your name" />
                </div>

                {/* email label */}
                <div className="mb-4">
                  <label className="block text-gray-700 mb-2" htmlFor="email">Email</label>
                  <input type="email" name="email" id="email" className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Your Email" />
                </div>

                {/* message label */}
                <div className="mb-4">
                  <label className="block text-gray-700 mb-2" htmlFor="message">Message</label>
                  <textarea name="message" id="message" rows={4} className="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Your message"></textarea>
                </div>

                {/* send button */}
                <button type="submit" className="w-full bg-blue-600 text-white py-3 rounded-md hover:bg-blue-700">Send Message</button>
              </form>
            </div>

            {/* contact details */}
            <div className="md:w-1/2">
              <div className="bg-white p-8 rounded-lg shadow-md h-full">
                <h3 className="text-xl font-semibold mb-6">Get in touch</h3>
                <div className="space-y-4">

                  {/* Address */}
                  <div className="flex items-start gap-3">
                    <span><img src="/address.png" alt="address" width={40} /></span>
                    <div className="">
                      <h4 className="font-semibold">Address</h4>
                      <p className="text-gray-700">123 Tech Street</p>
                    </div>
                  </div>

                  {/* Phone */}
                  <div className="flex items-start gap-3">
                    <span><img src="/phone.svg" alt="phone" width={40} /></span>
                    <div className="">
                      <h4 className="font-semibold">Phone</h4>
                      <p className="text-gray-700">+254 791 738 418</p>
                    </div>
                  </div>

                  {/* Email */}
                  <div className="flex items-start gap-3">
                    <span><img src="/email.svg" alt="email" width={40} /></span>
                    <div className="">
                      <h4 className="font-semibold">Email</h4>
                      <p className="text-gray-700">mutidawilz@gmail.com</p>
                    </div>
                  </div>

                  {/* working hours */}
                  <div className="flex items-start gap-3">
                    <span><img src="/hour.png" alt="hour" width={40} /></span>
                    <div className="">
                      <h4 className="font-semibold">Working Hours</h4>
                      <p className="text-gray-700">Monday-Friday: 9am-8pm</p>
                      <p className="text-gray-700">Saturday-Sunday: 10am-6pm</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-800 text-white py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">

            <div className="">
              <h3 className="text-xl font-semibold mb-4">ElectroHub</h3>
              <p className="text-gray-400">Your trusted partner for all electronics since 2020.</p>
            </div>

            <div className="">
              <h4 className="font-semibold mb-4">Quick Links</h4>
              <ul className="space-y-4">
                <li><a href="#" className="text-gray-400 hover:text-white">Home</a></li>
                <li><a href="#about" className="text-gray-400 hover:text-white">About Us</a></li>
                <li><a href="#features" className="text-gray-400 hover:text-white">Features</a></li>
                <li><a href="#contact" className="text-gray-400 hover:text-white">Contact Us</a></li>
              </ul>
            </div>

            {/* categories */}
            <div className="">
              <h4 className="font-semibold mb-4">Categories</h4>
              <ul className="space-y-2">
                <li><a href="#" className="text-gray-400 hover:text-white">Smartphones</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white">Laptops</a></li>
                <li><a href="#" className="text-gray-400 hover:text-white">Audio devices</a></li>

                <li><a href="#" className="text-gray-400 hover:text-white">Accessories</a></li>
              </ul>
            </div>

            <div className="">
              <h4 className="font-semibold mb-4">Newsletter</h4>
              <p className="text-gray-400 mb-4">Subscribe for updates and offers</p>

              <div className="flex">
                <input type="email" name="email" id="email" placeholder="mutidawilz@gmail.com" className="px-4 py-2 rounded-l-md w-full text-gray-800" />
                <button className="bg-blue-600 px-4 py-2 rounded-r-md hover:bg-blue-700">
                  Subscribe
                </button>
              </div>
            </div>
          </div>

          {/* copyright */}
          <div className="">
            <p>© {new Date().getFullYear()}. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default Home
