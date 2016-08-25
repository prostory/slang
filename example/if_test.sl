def foo(a, b, c)
  if b == 1 then 1 else 2 end
end

printf "%d\n", foo a = -5, if a > 0 then 1 else 0 end, if a < 0 then 1 else 0 end
printf "%d\n", foo b = if a > 0 then 1 else 0 end, 1, 0

printf "%d\n", if a > 0 then 1 else 0 end
