defmodule PentoWeb.WrongLive do
    use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
    
    def mount(_params, _session, socket) do
        {
            :ok,
            assign(
                socket,
                score: 0,
                message: "Make a guess:",
                time: time(),
                number: Enum.random(1..10)
            )
        }
    end

    def render(assigns) do
        ~H"""
        <h1>Your score: <%= @score %></h1>
        <a href="#" phx-click="reset">Reset Score</a>
        <h2>
            <%= @message %> <br>
            It's time <%= @time %>
        </h2>
        <h2>
            <%= for n <- 1..10 do %>
                <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
            <% end %>
        </h2>
        """
    end

    def handle_event("reset", _params, socket) do
    {
        :noreply,
        assign(
            socket,
            score: 0,
            message: "Make a guess:",
            time: time(),
            number: Enum.random(1..10)
        )
    }
    end


    def handle_event("guess", %{"number" => guess}=data, socket) do
        guess_number = String.to_integer(guess)
        random_number = socket.assigns.number
       
        {score, message, random_number} = 
        cond do
            random_number == guess_number ->
                 correct_guess(guess_number, socket)
            true  -> 
                wrong_guess(guess_number, socket)

        end

        {
            :noreply,
            assign(socket,
                score: score,
                message: message,
                time: time(),
                number: random_number
            )
        }
    end

    def correct_guess(guess, socket) do
        message = "Your guess: #{guess}. Correct! "
        score = socket.assigns.score + 1
        random_number = Enum.random(1..10)

        {
           score,
           message,
           random_number
        }
    end

    def wrong_guess(guess, socket) do
        message = "Your guess: #{guess}. Wrong. Guess again. "
        score = socket.assigns.score - 1
        random_number = socket.assigns.number
        {
            score,
            message,
            random_number
        }
    end


    def time() do
        DateTime.utc_now |> to_string
    end
end