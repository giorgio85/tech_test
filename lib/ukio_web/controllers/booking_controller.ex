defmodule UkioWeb.BookingController do
  use UkioWeb, :controller

  alias Ukio.Apartments
  alias Ukio.Apartments.Booking
  alias Ukio.Bookings.Handlers.BookingCreator

  action_fallback UkioWeb.FallbackController

  def create(conn, %{"booking" => booking_params}) do
    case BookingCreator.create(booking_params) do
      {:ok, booking} ->
        conn
        |> put_status(:created)
        |> render(:show, booking: booking)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)})

      {:error, "The apartment is already booked for the given dates: " <> _message = error_message} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: error_message})
    end
  end

  def show(conn, %{"id" => id}) do
    booking = Apartments.get_booking!(id)
    render(conn, :show, booking: booking)
  end

  def index(conn, _params) do
    bookings = Apartments.list_bookings()
    render(conn, :index, bookings: bookings)
  end

  defp translate_error({msg, opts}) do
    # Default translation logic for changeset errors
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
