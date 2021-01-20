using CSV
using DataFrames

function recolector(archivos::Array{String,undef}, columnas::Array{String,undef}, ruta::String)
    #Extraer la informacion de los archivos
    count = 1
    arreglo::Array{undef,undef}

    for i in archivos
        arreglo[count] = DataFrame(CSV.File(i))
        count = count + 1
    end

    #Crear otro dataframe pero este contendra solo las columnas requeridas
    df = DataFrame()
    for i in 1:count, for j in 1:length(columnas)
        #ESTO NO FUNCIONA
        #if names(arreglo[i]) == columnas[j]
        #    push!(df, COLUMNA)
        #end
    end

    #Crear un archivo csv con el dataframe
    CSV.write(ruta ,df)
end
