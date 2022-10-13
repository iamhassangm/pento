defmodule PentoWeb.UserAuthLive do
    import Phoenix.LiveView
    alias Pento.Accounts

    def on_mount(_, params, %{"user_token" => user_token}, socket) do
        fetch_user = &Accounts.get_user_by_session_token(&1)
        socket =
            socket
            |> assign_new(:current_user, fn -> fetch_user.(user_token) end )
        if socket.assigns.current_user do
            {:cont, socket}
        else
            {:halt, redirect(socket, to: "/login")}
        end
    end

    def fetch_user(user_token) do
        Accounts.get_user_by_session_token(user_token)
    end
end