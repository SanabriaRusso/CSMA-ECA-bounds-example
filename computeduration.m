function duration = computeduration(framelength, rate)

dsss = [1 2 5.5 11];
ofdm = [6 9 12 18 24 36 48 54];

if any(rate == dsss),
  % only long preamble
  duration = 192 + ceil(framelength * 8 /rate);
elseif any(rate == ofdm),
  ndbpss = [24 36 48 72 96 144 192 216];
  rateidx = find(ofdm == rate);
  ndbps = ndbpss(rateidx);
  plcp = 20;
  bits = 16 + framelength * 8 + 6;
  symbols = ceil(bits / ndbps);
  pause = 6;
  duration = plcp + 4 * symbols + pause;
else
  error('rate_invalid', 'The rate does not correspond to any known one');
end;