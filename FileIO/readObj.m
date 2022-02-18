function obj = readObj(obj_file, varargin)
    % obj = readObj(fname)
    %
    % This function parses wavefront object data
    % It reads the mesh vertices, texture coordinates, normal coordinates
    % and face definitions(grouped by number of vertices) in a .obj file 
    % 
    %
    % INPUT: obj_file - wavefront object file full path
    %        varargin{1} - material (*.mtl) file path, optional
    %
    % OUTPUT: obj.v - mesh vertices
    %       : obj.vt - texture coordinates
    %       : obj.fn - normal coordinates
    %       : obj.f - face definition assuming faces are made of of 3 vertices
    %       : obj.fKd - Diffuse reflection coefficient for each face, 1 by
    %       default if no mtl file provided
    %
    % Bernard Abayowa, Tec^Edge
    % 11/8/07
    % Updated by Liam Robinson, 1/4/2022
    
    % get field counts
    obj_lines = char(readlines(obj_file));
    v_count = sum(sum(obj_lines(:, 1:2) == 'v ', 2) > 1);
    vt_count = sum(sum(obj_lines(:, 1:2) == 'vt', 2) > 1);
    vn_count = sum(sum(obj_lines(:, 1:2) == 'vn', 2) > 1);
    f_count = sum(sum(obj_lines(:, 1:2) == 'f ', 2) > 1);

    % set up fields
    v = zeros(v_count,3); 
    vt = zeros(vt_count,2); 
    fn = zeros(vn_count,3); 
    f.v = zeros(f_count,3); 
    f.vt = zeros(f_count,2); 
    f.fn = zeros(f_count,3); 
    mats = []; 
    
    fid = fopen(obj_file);
    
    % parse .obj file 
    v_ind = 1;
    vt_ind = 1;
    vn_ind = 1;
    f_ind = 1;
    while 1    
        tline = fgetl(fid);
        if ~ischar(tline)
            break  
        end  % exit at end of file 
        ln = sscanf(tline,'%s',1); % line type 
        switch ln
            case 'o'
                
            case 'usemtl'
                mats = [mats; string(sscanf(tline(8:end),'%s'))];

            case 'v'   % mesh vertexs
                v(v_ind,:) = sscanf(tline(2:end),'%f')';
                v_ind = v_ind + 1;

            case 'vt'  % texture coordinate
                vt(vt_ind,:) = sscanf(tline(3:end),'%f')';
                vt_ind = vt_ind + 1;

            case 'vn'  % normal coordinate
                fn(vn_ind,:) = sscanf(tline(3:end),'%f')';
                vn_ind = vn_ind + 1;

            case 'f'   % face definition
                str = textscan(tline(2:end),'%s'); str = str{1};
                nf = length(findstr(str{1},'/')); % number of fields with this face vertices
                
                [tok, rem] = strtok(str,'//');     % vertex only
                f.v(f_ind, :) = [str2double(tok{1}), str2double(tok{2}), str2double(tok{3})]; 
               
                if (nf > 0) 
                   [tok, rem] = strtok(rem,'//');   % add texture coordinates
                   f.vt(f_ind, :) = [str2double(tok{1}), str2double(tok{2})]; 
                end

                if (nf > 1) 
                    [tok, ~] = strtok(rem,'//');   % add normal coordinates
                    f.fn(f_ind, :) = [str2double(tok{1}), str2double(tok{2}), str2double(tok{3})];
                end

                f_ind = f_ind + 1;
        end
    end
    fclose(fid);
    
    % set up matlab object 
    obj.v = v; obj.vt = vt; obj.fn = fn; obj.f = f;
    
    %%%%% MATERIAL LOADING
    if nargin > 1
        obj.mats = mats; obj.mat_verts = v_count;

        mtl = readMtl(varargin{1});
        obj_index_of_face = @(obj, face_index) find(obj.mat_verts > obj.f.v(face_index, 1), 1, 'first')-1;
        obj_mat_of_face = @(obj, face_index) obj.mats(obj_index_of_face(obj, face_index));
        Kd_of_face = @(obj, face_index) mtl.Kd(mtl.mat_name == obj_mat_of_face(obj, face_index), :);
        obj.fKd = zeros(f_count, 1);
    
        
        for i = 1:length(obj.f.v)
            Kd_of_face(obj, i)
            obj.fKd(i, :) = Kd_of_face(obj, i);
        end
    else
        for i = 1:length(obj.f.v)
            obj.fKd(i, :) = 1.0;
        end
    end
end
