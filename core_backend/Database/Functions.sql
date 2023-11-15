CREATE FUNCTION dbo.udf_Haversine(@lat1 float, @long1 float, @lat2 float, @long2 float) RETURNS float 
  BEGIN
    DECLARE @dlon float, @dlat float, @rlat1 float, @rlat2 float, @rlong1 float, @rlong2 float, @a float, @c float, @R float, @d float, @DtoR float

    SELECT @DtoR = 0.017453293
    SELECT @R = 3937 --3976

    SELECT 
        @rlat1 = @lat1 * @DtoR,
        @rlong1 = @long1 * @DtoR,
        @rlat2 = @lat2 * @DtoR,
        @rlong2 = @long2 * @DtoR

    SELECT 
        @dlon = @rlong1 - @rlong2,
        @dlat = @rlat1 - @rlat2

    SELECT @a = power(sin(@dlat/2), 2) + cos(@rlat1) * cos(@rlat2) * power(sin(@dlon/2), 2)
    SELECT @c = 2 * atn2(sqrt(@a), sqrt(1-@a))
    SELECT @d = @R * @c

    RETURN @d 
  END
