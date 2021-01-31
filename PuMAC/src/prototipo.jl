using CSV
using DataFrames

function con_archivos(archivos::Array{String,undef}, columnas::Array{String,undef}, ruta::String = homedir(), exportto::String = "csv", faltantes::Bool = true)
    #Extraer la informacion de los archivos
    count = 0
    arreglo = Array{DataFrame}(undef,size(archivos,1)
    tamanio = 0

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
             arreglo[i] = select!(arreglo[i], Not(Symbol(j)))   
        end
    end


    for i in 1:size(archivos,1)#, for j in 1:tamanio
        if nrow(arreglo[i]) < tamanio
#crar un dataframe con numero de filas del tamaño de nrow(arreglo[i])-tamanio
# e insertarlo abajo de arreglo[i]
            arreglo[i] = push!(arreglo[i],#columnas de missing#)
        end
    end

    #Crear un archivo csv con el dataframe
    if(exportto == "csv")
        CSV.write(ruta ,df)
    end
    else  if(exportto == "jld")
        CSV.write(ruta ,df)
    end
    
    return nevo_dataframe
end

function con_carpeta(archivos::String, columnas::Array{String,undef}, ruta::String)
end
