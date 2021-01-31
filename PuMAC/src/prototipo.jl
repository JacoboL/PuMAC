using CSV
using DataFrames
using JLD

function con_archivos(archivos::Array{String,undef}, columnas::Array{String,undef}, nombre_ruta::String, exportto::String = "csv", faltantes::Bool = true)
    #Extraer la informacion de los archivos
    count = 0
    arreglo = Array{DataFrame}(undef,size(archivos,1)
    tamanio = 0
        nuevo_dataframe = DataFrame()

    for i in archivos
        arreglo[count] = DataFrame(CSV.File(i))
        count = count + 1
        if tamanio < size(arreglo[count],1)
            tamanio = size(arreglo[count],1)
        end
    end

#quitar columnas no requeridas de los dataframes

#arreglo[] = Dataframes que contienen los archivos

    for i in 1:size(archivos,1), j in names(arreglo[i]), k in columnas
        #quitar columnas no requeridas, los nombres
        #de las columnas estan en un arreglo
        #llamado "columnas" de tipo string
        if(j==k)
             arreglo[i] = select(arreglo[i], Symbol(j))   
        end
        if(j!=k)
             select!(arreglo[i], Not(Symbol(j)))   
        end
    end


    for i in 1:size(archivos,1)#, for j in 1:tamanio
        if nrow(arreglo[i]) < tamanio
#crar un dataframe con numero de filas del tamaño de nrow(arreglo[i])-tamanio
# e insertarlo abajo de arreglo[i]
            arreglo[i] = push!(arreglo[i],#columnas de missing#)
        end
    end
    
    for i in 1:size(archivos,1)#, for j in 1:tamanio
       nuevo_dataframe = hcat(nuevo_dataframe, arreglo[i], makeunique=true)
    end

    #Crear un archivo csv con el dataframe
    if(lowercase(exportto) == "csv")
        CSV.write( joinpath(homedir(), nombre_ruta) ,nuevo_dataframe)
        println("el archivo se guardo en", joinpath(homedir(), nombre_ruta))
    else  if(lowercase(exportto) == "jld")
        #exportar a jld
    else
        println("no se puede exportar al tipo de archivo $exportto")
    end
      
    
    return nevo_dataframe
end

function con_carpeta(archivos::String, columnas::Array{String,undef}, ruta::String = homedir(), exportto::String = "csv", faltantes::Bool = true)
end
