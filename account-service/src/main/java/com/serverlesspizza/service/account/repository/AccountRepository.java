package com.serverlesspizza.service.account.repository;

import com.serverlesspizza.service.account.domain.Account;
import org.socialsignin.spring.data.dynamodb.repository.EnableScan;
import org.springframework.data.repository.CrudRepository;

@EnableScan
public interface AccountRepository extends CrudRepository<Account, String> {

}
