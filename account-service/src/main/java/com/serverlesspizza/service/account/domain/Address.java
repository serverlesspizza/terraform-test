package com.serverlesspizza.service.account.domain;

import com.amazonaws.services.dynamodbv2.datamodeling.*;

@DynamoDBDocument
public class Address {

    @DynamoDBAttribute
    private String numberOrName;

    @DynamoDBAttribute
    private String street;

    @DynamoDBAttribute
    private String county;

    @DynamoDBAttribute
    private String postCode;

    public String getNumberOrName() {
        return numberOrName;
    }

    public void setNumberOrName(String numberOrName) {
        this.numberOrName = numberOrName;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getCounty() {
        return county;
    }

    public void setCounty(String county) {
        this.county = county;
    }

    public String getPostCode() {
        return postCode;
    }

    public void setPostCode(String postCode) {
        this.postCode = postCode;
    }
}
