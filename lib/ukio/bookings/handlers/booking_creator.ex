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
    market = apartment.market || "default"
    rules = Map.get(market_rules(), market, market_rules()["default"])

    deposit =
      case rules["deposit"] do
        "monthly_rent" -> apartment.monthly_price
        fixed_value when is_integer(fixed_value) -> fixed_value
      end

    utilities =
      case rules["utilities"] do
        value when is_integer(value) -> value
        expression when is_binary(expression) ->
          {result, _} = Code.eval_string(expression, square_meters: apartment.square_meters)
          result
      end

    %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: apartment.monthly_price,
      utilities: utilities,
      deposit: deposit
    }
  end

  # Loading market rules from a JSON file
  # This is a simple example. In a real-world application, we might want to
  # load this data from a database or an external service.
  defp market_rules do
    "priv/market_rules.json"
    |> File.read!()
    |> Jason.decode!()
  end
end
