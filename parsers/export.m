function export(fn, outdir)

## Usage: export(fn, outdir)
##
## Exports data from a MARSIS file as JSON.
##
## Export a lot of files like this:
##
##  >> cellfun(@(x) @export(x, "outputdir"), glob("/path/to/files/000*"))
##

if (nargin() == 1)
  outdir = '.'
endif

[ ORBIT_NUMBER, ...
           OST_LINE_NUMBER, ...
           FRAME_ID, ...
           SCET_FRAME_WHOLE, ...
           SCET_FRAME_FRAC, ...
           CENTRAL_FREQUENCY, ...
           MARS_SOLAR_LONGITUDE, ...
           SPACECRAFT_ALTITUDE, ...
           SUB_SC_LONGITUDE, ...
           SUB_SC_LATITUDE, ...
           LOCAL_TRUE_SOLAR_TIME, ...
           SOLAR_ZENITH_ANGLE, ...
           FOOTPRINT_CENTER_LONGITUDE, ...
           FOOTPRINT_CENTER_LATITUDE, ...
           FOOTPRINT_VERTEX_LONGITUDE, ...
           FOOTPRINT_VERTEX_LATITUDE, ...
           ROUGHNESS_WITHIN_FOOTPRINT, ...
           INCIDENCE_ANGLE, ...
           FRESNEL_RADIUS, ...
           ECHO_MODULUS_MINUS1_F1_NO_IONO, ...
           ECHO_MODULUS_ZERO_F1_NO_IONO, ...
           ECHO_MODULUS_PLUS1_F1_NO_IONO, ...
           ECHO_MODULUS_MINUS1_F2_NO_IONO, ...
           ECHO_MODULUS_ZERO_F2_NO_IONO, ...
           ECHO_MODULUS_PLUS1_F2_NO_IONO, ...
           ECHO_MODULUS_MINUS1_F1_IONO, ...
           ECHO_MODULUS_ZERO_F1_IONO, ...
           ECHO_MODULUS_PLUS1_F1_IONO, ...
           ECHO_MODULUS_MINUS1_F2_IONO, ...
           ECHO_MODULUS_ZERO_F2_IONO, ...
           ECHO_MODULUS_PLUS1_F2_IONO, ...
           ECHO_MODULUS_MINUS1_F1_SIM, ...
           ECHO_MODULUS_ZERO_F1_SIM, ...
           ECHO_MODULUS_PLUS1_F1_SIM, ...
           ECHO_MODULUS_MINUS1_F2_SIM, ...
           ECHO_MODULUS_ZERO_F2_SIM, ...
           ECHO_MODULUS_PLUS1_F2_SIM ] = readmarsiscdr(fn);

for i = 1:size(FRAME_ID, 2)
  outfilename = fullfile(outdir, sprintf("%08d,%08d,%08d,%08.4f,%08.4f", ...
      ORBIT_NUMBER(i), OST_LINE_NUMBER(i), FRAME_ID(i), SUB_SC_LATITUDE(i), SUB_SC_LONGITUDE(i)));
  f = fopen(outfilename, 'w');
  fprintf(f, '{ "latitude": %f, "longitude": %f, "alt": %f, "orbit": %d, "line": %d, "frame": %d,\n "iono": [', ...
      SUB_SC_LATITUDE(i), SUB_SC_LONGITUDE(i), SPACECRAFT_ALTITUDE(i),...
      ORBIT_NUMBER(i), OST_LINE_NUMBER(i), FRAME_ID(i));
  iono = ECHO_MODULUS_ZERO_F1_IONO(:,i);
  for j = 1:size(iono)
    if (j == 1)
      fprintf(f, "%f", iono(j));
    else
      fprintf(f, ", %f", iono(j));
    endif
  endfor
  fprintf(f, '],\n"sim":[');
  sim = ECHO_MODULUS_MINUS1_F1_SIM(:,i);
  for j = 1:size(sim)
    if (j == 1)
      fprintf(f, "%f", sim(j));
    else
      fprintf(f, ", %f", sim(j));
    endif
  endfor
  fprintf(f, "]\n}");
  fclose(f);
endfor

endfunction
