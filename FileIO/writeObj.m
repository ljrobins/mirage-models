function writeObj(obj, fpath, fname)
    cd(fpath)
    fid = fopen(fname, 'w');
    
    header = "# MATLAB writeObj() OBJ File: ''\n" + ...
             sprintf("o %s\n", fname);

    fprintf(fid, header);

    data = "";

    for i = 1:length(obj.v)
        data = data + sprintf("v %.6f %.6f %.6f\n", obj.v(i, :));
    end

    if isfield(obj, 'vt')
        for i = 1:length(obj.vt)
            data = data + sprintf("vt %.6f %.6f\n", obj.vt(i, :));
        end
    end

    for i = 1:length(obj.fn)
        data = data + sprintf("vn %.6f %.6f %.6f\n", obj.fn(i, :));
    end

    data = data + "s off\n";

    if isfield(obj, 'vt')
        for i = 1:length(obj.f.v)
            face_mat = [obj.f.v(i, :); obj.f.vt(i, :); obj.f.fn(i, :)];
            data = data + sprintf("f %d/%d/%d %d/%d/%d %d/%d/%d\n", reshape(face_mat, 1, []));
        end

    else
        for i = 1:length(obj.f.v)
            face_mat = [obj.f.v(i, :); obj.f.fn(i, :)];
            data = data + sprintf("f %d//%d %d//%d %d//%d\n", reshape(face_mat, 1, []));
        end
    end

    fprintf(fid, data);

    fclose(fid);
end
