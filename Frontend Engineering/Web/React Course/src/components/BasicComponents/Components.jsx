import React from "react";

const Component = () => {
  return (
    <div className="min-h-screen bg-gray-100 font-sans">
      {/* Hero Section */}
      <header className="bg-blue-600 text-white text-center py-20">
        <div className="container mx-auto px-4">
          <h1 className="text-4xl font-bold mb-4">Welcome to Our Service</h1>
          <p className="text-xl mb-8">
            Empowering your business with innovative solutions.
          </p>
          <a
            href="#contact"
            className="bg-yellow-500 text-blue-800 py-2 px-6 rounded-lg shadow-md hover:bg-yellow-600 transition duration-300"
          >
            Get Started
          </a>
        </div>
      </header>

      {/* Features Section */}
      <section className="py-16">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-semibold text-center mb-12">
            Our Features
          </h2>
          <div className="flex flex-wrap -mx-4">
            <div className="w-full md:w-1/3 px-4 mb-8">
              <div className="bg-white p-6 rounded-lg shadow-lg">
                <h3 className="text-xl font-semibold mb-4">Feature One</h3>
                <p className="text-gray-700">
                  Description of the first feature goes here. It highlights the
                  key benefit.
                </p>
              </div>
            </div>
            <div className="w-full md:w-1/3 px-4 mb-8">
              <div className="bg-white p-6 rounded-lg shadow-lg">
                <h3 className="text-xl font-semibold mb-4">Feature Two</h3>
                <p className="text-gray-700">
                  Description of the second feature goes here. It emphasizes
                  another key benefit.
                </p>
              </div>
            </div>
            <div className="w-full md:w-1/3 px-4 mb-8">
              <div className="bg-white p-6 rounded-lg shadow-lg">
                <h3 className="text-xl font-semibold mb-4">Feature Three</h3>
                <p className="text-gray-700">
                  Description of the third feature goes here. It highlights yet
                  another benefit.
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section className="bg-gray-200 py-16">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-semibold text-center mb-12">
            What Our Clients Say
          </h2>
          <div className="flex flex-wrap -mx-4">
            <div className="w-full md:w-1/2 px-4 mb-8">
              <div className="bg-white p-6 rounded-lg shadow-lg">
                <p className="text-gray-700 mb-4">
                  "This service has been a game changer for our business. Highly
                  recommend!"
                </p>
                <p className="font-semibold">Jane Doe</p>
                <p className="text-gray-600">CEO, Company A</p>
              </div>
            </div>
            <div className="w-full md:w-1/2 px-4 mb-8">
              <div className="bg-white p-6 rounded-lg shadow-lg">
                <p className="text-gray-700 mb-4">
                  "Amazing results and fantastic support. We couldn’t ask for
                  more."
                </p>
                <p className="font-semibold">John Smith</p>
                <p className="text-gray-600">CTO, Company B</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Contact Section */}
      <section id="contact" className="py-16">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-semibold text-center mb-8">
            Contact Us
          </h2>
          <div className="flex justify-center">
            <a
              href="mailto:contact@ourservice.com"
              className="bg-blue-600 text-white py-3 px-6 rounded-lg shadow-md hover:bg-blue-700 transition duration-300"
            >
              Email Us
            </a>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-800 text-white text-center py-4">
        <p className="text-sm">&copy; 2024 Our Service. All rights reserved.</p>
      </footer>
    </div>
  );
};

export default Component;
