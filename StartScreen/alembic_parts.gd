extends CurrencyStack

func should_include(currency: Currency) -> bool:
	return currency.alembic_part
