using CSV
using DataFrames
using JLD
using FileIO

columnas = ["po","pob_f", "pob_m", "contr_nal", "nom_ent", "INEGI. Encuesta Intercensal 2015", "Va_cte", "ivf_itaee"]

function concatenador(archivos::Array, columnas::Array, nombre_archivo::String = "new_PuMAC.csv", faltantes::Bool = true)

    # Asegurando que los valores introducidos sean los esperados
    if(size(archivos,1) < 1)
        error("Pon archivos csv para extraer, debe de ser un arreglo de tipo String")
    end
    
    for i in archivos
        if(contains(i, ".csv"))
            error("Algun archivo no es csv o esta mal escrito, asegurarse que sea de la forma [\"Archivo_1.csv\", \"Archivo_2.csv\", ...]")
        elseif(contains(i, ".jld"))
            error("Algun archivo no es jld o esta mal escrito, asegurarse que sea de la forma [\"Archivo_1.jld\", \"Archivo_2.jld\", ...]")
        end
    end
    
    if(size(columnas,1) < 1)
        error("Pon las columnas que quieres extraer, debe de ser un arreglo de tipo String")
    end
        
    if(!contains(nombre_archivo, ".jld"))
        error("El String que contiene al archivo necesita tener el tipo de archivo especificado o tipo de archivo no soportado")
    end

    # Se declara un arreglo con la misma cantidad de espacio que la cantidad de archivos pasados por el usuario
    arreglo = Array{DataFrame}(undef,size(archivos,1))
    tamanio = 0
    #count = 0

    # Se extraen todos los archivos csv como DataFrames y se guardan en el arreglo,
    # tambien se obtiene la dimension del DataFrame mas grande
    cd("C:\\Users\\pillo\\OneDrive\\Escritorio\\Archivos")
    for i in 1:size(archivos,1)
        arreglo[i] = DataFrame(CSV.File(archivos[i]))
        if tamanio < size(arreglo[i],1)
            tamanio = size(arreglo[i],1)
        end
        #=for j in names(arreglo[i])
            if(k == j)
                count = count +1
            end
        end=#
    end
    
    #if(count == 0)
    #    println("WARNING: una columna deseada no esta en los Archivos")
    #end

    # Se declara un Dataframe con la misma cardinalidad del DataFrame mas grande
    df_nuevo = DataFrame(ПУМАК = 1:tamanio)

    for i in 1:size(archivos,1), j in 1:size(names(arreglo[i]),1), k in columnas
        # Se obtienen solo las columnas deseadas por el usuario
        if (k == names(arreglo[i])[j])
            # Se asigna a x con los calores de la columna deseada por el usuario
            x = arreglo[i][:,k]
            # Se convierte a x en tipo Any
            x = convert(Array{Any,1}, x)

            # Se normalizan filas de DataFrames con cardinalidad menor que la mas grande,
            # si faltantes es true entonces los valores faltantes se normalizaran con el valor de missing, de otro modo se normalizara con ceros
            if(nrow(arreglo[i]) < tamanio)
                if (faltantes)
                    append!(x, Array{Missing}(undef, tamanio-nrow(arreglo[i])))
                else
                    append!(x, zeros(tamanio-nrow(arreglo[i])))
                end
            end

            # Se agrega la columna x al DataFrame
            df_nuevo = hcat(df_nuevo, DataFrame(Symbol(k) => x), makeunique=true)
        end
    end

    # Se retira la columna auxiliar "ПУМАК" del DataFrame
    select!(df_nuevo, Not("ПУМАК"))

    # Se exporta al tipo de archivo deseado
    if(contains(nombre_archivo, ".csv"))
        CSV.write(nombre_archivo , df_nuevo)
        print("el archivo se guardo en: ")
        println( joinpath( pwd(), nombre_archivo))
    elseif(contains(nombre_archivo, ".jld"))
        save(joinpath(pwd(), nombre_archivo), "df", df_nuevo)
        print("el archivo se guardo en: ")
        println( joinpath( pwd(), nombre_archivo))
    end

    return df_nuevo
end


function concatenador(carpeta::String, columnas::Array, nombre_archivo::String = "new_PuMAC.csv", faltantes::Bool = true)
    # Se extraen los archivos de tipo csv de la carpeta
    cd(carpeta)
    archivos = filter(x->endswith(x, ".csv"), readdir())

    concatenador(archivos, columnas, nombre_archivo, faltantes)
end

Z = concatenador("C:\\Users\\pillo\\OneDrive\\Escritorio\\Archivos", columnas, "PrimeraPrueba.csv")
