using CSV
using DataFrames
using JLD

function con_archivos(archivos::Array{String,undef}, columnas::Array{String,undef}, nombre_archivo::String, ruta::String = homedir(), exportto::String = "csv", faltantes::Bool = true)

    arreglo = Array{DataFrame}(undef,size(archivos,1))
    tamanio = 0

    for i in 1:size(archivos,1)
        arreglo[i] = DataFrame(CSV.File(archivos[i]))
        if tamanio < size(arreglo[i],1)
            tamanio = size(arreglo[i],1)
        end
    end

    df_nuevo = DataFrame(ПУМАК = 1:tamanio)

for i in 1:size(archivos,1), j in 1:size(names(arreglo[i]),1), k in columnas
    if (k == names(arreglo[i])[j])
        x = arreglo[i][:,k]
        x = convert(Array{Any,1}, x)
        
        if(nrow(arreglo[i]) < tamanio)
            if faltantes
                append!(x, Array{Missing}(undef, tamanio-nrow(arreglo[i])))
            else
                append!(x, zeros(tamanio-nrow(arreglo[i])))
            end
        end
        
        df_nuevo = hcat(df_nuevo, x, makeunique=true)
    end
end
select!(df_nuevo, Not("ПУМАК"))

    if(lowercase(exportto) == "csv")
        
        CSV.write(nombre_archivo , df_nuevo)
            
        println("el archivo se guardo en", joinpath(homedir(), nombre_ruta))
    else  if(lowercase(exportto) == "jld")
        #exportar a jld
    else
        error("no se puede exportar al tipo de archivo $exportto")
    end
      
    
    return df_nuevo
end

function con_carpeta(carpeta::String, columnas::Array{String,undef}, nombre_archivo::String, exportto::String = "csv", faltantes::Bool = true)
    cd(carpeta)
    archivos = filter(x->endswith(x, ".csv"), readdir())
end
