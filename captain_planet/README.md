Captain Planet, he's our hero. He's gonna take pollution down to zero.

Well, actually Captain Planet's job can be quite tedious sometimes. He has to sort through tons and tons of data to find out which countries of the world need help lowering the pollution in the air. Having the powers of Earth, wind, water, fire and heart doesn't make you any faster at trudging through paperwork.

You will be given a global variable `dataFile` (`$data_file` in ruby) which will hold output like:
```
##################################
Location: DEU
##################################
Ammonia: 023 particles
Nitrogen Oxide: 019 particles
Carbon Monoxide: 127 particles
##################################
##################################
Location: USA
##################################
Ammonia: 200 particles
Nitrogen Oxide: 120 particles
Carbon Monoxide: 120 particles
##################################
##################################
Location: AUS
##################################
Ammonia: 122 particles
Nitrogen Oxide: 132 particles
Carbon Monoxide: 099 particles
##################################
```

Don't bust out your gas masks, this data isn't real. Our job now is to supply Captain Planet with some easily readable results. A call to `parseData()` (`parse_data`) in this case should yield the following result:
```
parseData() ->
"Ammonia levels in USA are too high. Nitrogen Oxide levels in AUS are too high. Carbon Monoxide levels in DEU are too high."
```

Multiple locations will be given and they will all have results in Ammonia, Nitrogen Oxide and Carbon Monoxide but may also have other data. That data should be ignored. The original dataFile variable must remain unchanged. If two or more countries have the highest amount of particles in one area, they should both be included in your result. They should appear in the order that they originally appear in the report. If the three countries listed above had the same ammonia levels, your result should look like this:
```
"Ammonia levels in DEU, USA, AUS are too high. <and so on>"
```
With our powers combined, we can help Captain Planet!

[Kata link](https://www.codewars.com/kata/568eeb1ce6f9e820c800000b)
