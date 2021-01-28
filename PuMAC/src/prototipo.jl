using CSV
using DataFrames

function recolector(archivos::Array{String,undef}, columnas::Array{String,undef}, ruta::String)
    #Extraer la informacion de los archivos
    count = 0
    arreglo::Array{undef,undef}
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

    for i in 1:size(archivos,1), for j in names(arreglo[i]), for k in columnas
        #quitar columnas no requeridas, los nombres
        #de las columnas estan en un arreglo
        #llamado "columnas" de tipo string
        if(j!=k)
             arreglo[i] = select!(arreglo[i], Not(:j))   
        end
    end


    for i in 1:size(archivos,1)#, for j in 1:tamanio
        if nrow(arreglo[i]) < tamanio
#crar un dataframe con numero de filas del tamaño de nrow(arreglo[i])-tamanio
# e insertarlo abajo de arreglo[i]
            arreglo[i] =
        end
    end

    #Crear un archivo csv con el dataframe
    CSV.write(ruta ,df)
end
