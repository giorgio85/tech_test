defmodule Ukio.Bookings.Handlers.BookingCreator do
  alias Ukio.Apartments

  def create(
        %{"check_in" => check_in, "check_out" => check_out, "apartment_id" => apartment_id} =
          _params
      ) do
    with a <- Apartments.get_apartment!(apartment_id),
         :ok <- validate_availability(apartment_id, check_in, check_out),
         b <- generate_booking_data(a, check_in, check_out),
         {:ok, booking} <- Apartments.create_booking(b) do
      {:ok, booking}
    else
      {:error, :apartment_already_booked} ->
        {:error, "The apartment is already booked for the given dates: #{check_in} to #{check_out}"}
    end
  end

  def validate_availability(apartment_id, check_in, check_out) do
    check_in = ensure_date(check_in)
    check_out = ensure_date(check_out)

    overlapping_bookings =
      Apartments.list_bookings()
      |> Enum.filter(fn booking ->
        booking.apartment_id == apartment_id and
          not (Date.compare(booking.check_out, check_in) == :lt or
               Date.compare(booking.check_in, check_out) == :gt)
      end)

    if overlapping_bookings == [] do
      :ok
    else
      {:error, :apartment_already_booked}
    end
  end

  defp ensure_date(%Date{} = date), do: date
  defp ensure_date(date) when is_binary(date), do: Date.from_iso8601!(date)
  defp ensure_date(nil), do: nil

  defp generate_booking_data(apartment, check_in, check_out) do
    %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: apartment.monthly_price,
      utilities: 20_000,
      deposit: 100_000
    }
  end
end
