#include <stdio.h>
#include <allegro5/allegro.h>
#include <allegro5/allegro_image.h>
#include <allegro5/allegro_primitives.h>
#include <string.h>
#include "median.h"

void changeName(char* inputName, char* outputName){
    strcpy(outputName,inputName);
    outputName[strlen(inputName)-4]='_';
    outputName[strlen(inputName)-3]='m';
    outputName[strlen(inputName)-2]='o';
    outputName[strlen(inputName)-1]='d';
    strcat(outputName,".bmp");
}

int main(int argc, char **argv)
{
    if (argc < 2)
    {
        printf("Nie podano nazwy pliku wejsciowego-prosze podac nazwe, razem z rozszerzeniem.bmp\n");
        return 0;
    }
    ALLEGRO_BITMAP *bitmapInput = NULL;
    if (!al_init() || !al_init_image_addon()|| !al_init_primitives_addon())
    {
        fprintf(stderr, "Nie udalo sie zainicjalizowac biblioteki graficznej\n");
        return -1;
    }
    char *inputName = argv[1];

    bitmapInput = al_load_bitmap(inputName);
    if (bitmapInput == NULL)
    {
        fprintf(stderr, "Nie udalo sie wczytac pliku, prosze upewnic sie ze istnieje\n");
        return -1;
    }

    int height = al_get_bitmap_height(bitmapInput);
    int width = al_get_bitmap_width(bitmapInput);

    unsigned char BM[2];
    FILE *inStream, *inStream2, *outStream;
    inStream = fopen(inputName, "r");
    int size, buff, offset;
    //fread(&val, sizeof(int), 1, fp);
    fread(&BM, 2, 1, inStream);
    fread(&size, 4, 1, inStream);
    fread(&buff, 4, 1, inStream);
    fread(&offset, 4, 1, inStream);
    fclose(inStream);

    //wczytalismy offset, takze juz wiemy ile bitow bedzie niezmienionych i ile musimy wczytac do tablicy

    unsigned char offsetTable[offset];
    int padding = width % 4;
    int tableSize = (width + padding) * height;
    unsigned char table[tableSize];
    unsigned char table2[tableSize];
    unsigned char window[25];

    inStream2 = fopen(inputName, "r");
    fread(&offsetTable, offset, 1, inStream);
    fread(&table, tableSize, 1, inStream);
    fclose(inStream2);

    median(table, table2, width, height, padding, window); //funkcja asemblerowa

    char outputName[strlen(inputName)+4];
    changeName(inputName,outputName);

    outStream=fopen(outputName,"w");
    fwrite(&offsetTable, offset, 1, outStream);
    fwrite(&table2, tableSize, 1, outStream);
    fclose(outStream);

    //wyswietlanie
    ALLEGRO_BITMAP *bitmapOutput=NULL;
    ALLEGRO_DISPLAY * display = NULL;
    bitmapOutput=al_load_bitmap(outputName);
    display=al_create_display(2*width,height);
    ALLEGRO_EVENT_QUEUE *queue;
    queue = al_create_event_queue();
    al_register_event_source(queue, al_get_display_event_source(display));
    bool userHasNotClickedX=true;

    while(userHasNotClickedX){
    al_draw_bitmap(bitmapInput,0,0,0);
    al_draw_line(width,0,width,height,al_map_rgb(100,200,255),11);
    al_draw_bitmap(bitmapOutput,width+1,0,0);
    al_flip_display();
    ALLEGRO_EVENT event;
		if (!al_is_event_queue_empty(queue)) {
			al_wait_for_event(queue, &event);
			if (event.type == ALLEGRO_EVENT_DISPLAY_CLOSE)
				userHasNotClickedX = false;
		}
    }
    return 0;
}
