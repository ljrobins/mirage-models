function mtl = readMtl(fname)
    fid = fopen(fname);
    % set up field types
    mat_names = []; Kd = []; Ka = []; Ke = []; Ks = []; Ns = [];
    while 1    
        tline = fgetl(fid);
        if ~ischar(tline),   break,   end  % exit at end of file 
        ln = sscanf(tline,'%s',1); % line type 
%         disp(tline)
        switch ln
            case 'newmtl'   % material name
                mat_names = [mat_names; string(sscanf(tline(8:end),'%s'))];
            case 'Kd'  % material diffuse reflection coefficient
                Kd = [Kd; sscanf(tline(3:end),'%f')'];
            case 'Ks'  % material diffuse reflection coefficient
                Ks = [Ks; sscanf(tline(3:end),'%f')'];
            case 'Ka'  % material diffuse reflection coefficient
                Ka = [Ka; sscanf(tline(3:end),'%f')'];
            case 'Ke'  % material diffuse reflection coefficient
                Ke = [Ke; sscanf(tline(3:end),'%f')'];
            case 'Ns'  % material diffuse reflection coefficient
                Ns = [Ns; sscanf(tline(3:end),'%f')'];
           
        end
    end
    fclose(fid);
    
    mtl = struct("mat_name", mat_names, "Kd", Kd, "Ka", Ka, "Ks", Ks, "Ke", Ke, "Ns", Ns);
end