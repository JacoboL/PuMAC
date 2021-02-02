using CSV
using DataFrames
using JLD

function con_archivos(archivos::Array{String,undef}, columnas::Array{String,undef}, nombre_archivo::String, ruta::String = homedir(), exportto::String = "csv", faltantes::Bool = true)

    count = 0
    arreglo = Array{DataFrame}(undef,size(archivos,1))
    tamanio = 0
    nuevo_dataframe = DataFrame()

    for i in archivos
        arreglo[count] = DataFrame(CSV.File(i))
        aux_arr[count] = DataFrame(ПУМАК = 1:nrow(arreglo[count]))
        if tamanio < size(arreglo[count],1)
            tamanio = size(arreglo[count],1)
        end
        count = count + 1
    end

    for i in 1:size(archivos,1), j in names(arreglo[i]), k in columnas
        if(j==k)
            aux_arr[i] = hcat(aux_arr[i],select(arreglo[i], Symbol(j)),makeunique=true)
        end
    end
        
    for i in 1:size(aux_arr,1)
        select!(aux_arr[i], Not("ПУМАК"))
    end


    for i in 1:size(archivos,1)
        if nrow(arreglo[i]) < tamanio
            missing_dataframe = similar(arreglo[i], tamanio-nrow(arreglo[i]))
            #nuevos valores a missing
            append!(arreglo[i], missing_dataframe)
        end
    end
    
    for i in 1:size(archivos,1)
       nuevo_dataframe = hcat(nuevo_dataframe, arreglo[i], makeunique=true)
    end

    if(lowercase(exportto) == "csv")
        
        CSV.write(nombre_archivo ,nuevo_dataframe)
            
        println("el archivo se guardo en", joinpath(homedir(), nombre_ruta))
    else  if(lowercase(exportto) == "jld")
        #exportar a jld
    else
        error("no se puede exportar al tipo de archivo $exportto")
    end
      
    
    return nevo_dataframe
end

function con_carpeta(carpeta::String, columnas::Array{String,undef}, nombre_archivo::String, exportto::String = "csv", faltantes::Bool = true)
    cd(carpeta)
    archivos = filter(x->endswith(x, ".csv"), readdir())
end
