function rateBell = BellRate_from_errors(bellErr)

if isempty(bellErr.Xerr) || isempty(bellErr.Zerr)
    rateBell = 0;
    return;
end

rateBell = R_SecretKey6State_total(bellErr.Zerr, bellErr.Xerr);

end