public class largestnumber{
    public static void main(String[] args){

        int[] number = {10,20,30,40,50};
        int largest = number[0];
        for(int i = 1; i<number.length; i++)
{
    if(number[i] > largest){
        largest = number[i];

    }
}
System.out.println("The largest number is:"+largest);
    }
}