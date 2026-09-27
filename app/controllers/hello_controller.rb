class HelloController < ApplicationController
    def index
        render plain: "Hello, Rails!"
    end

    def view
        @msg = "Hello, Rails!"
    end

    def test
        @msg = "Hello, test!"
    end

    def list
        @books = Book.all
        # binding.break
    end
end
