class ActivityData{
   String? imageUrl;
    String? description;

   ActivityData(this.imageUrl, this.description);

   Map<String, dynamic> toJson() => {'imageUrl' : imageUrl, 'description' : description};

   ActivityData.fromSnapshot(snapshot):
     imageUrl = snapshot.data()['imageUrl'],
     description = snapshot.data()['description'];

}