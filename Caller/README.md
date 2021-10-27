Binary_to_Decimal.v---- for Seven-segment display, I use this module to output three digits decimal number from binary number(range(1-127))

Debounce.v---because after pushing the button the voltage will not immediately transfer from
3.3v->0v, thus I use a debounce.v module to ensure the voltage is stable 0v

LFSR.v(Linear-feedback shift register)---use the time of button down as seed of the LFSR to generate a random number
