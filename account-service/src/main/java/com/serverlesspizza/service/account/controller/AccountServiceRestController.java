package com.serverlesspizza.service.account.controller;

import com.serverlesspizza.service.account.domain.Account;
import com.serverlesspizza.service.account.repository.AccountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

import java.net.URI;
import java.util.Optional;

@RestController
@EnableWebMvc
@CrossOrigin(
    origins = {"https://www.serverlesspizza.com", "https://dev.serverlesspizza.com", "http://localhost:3000"},
    allowCredentials = "true",
    allowedHeaders = {"Authorization", "content-type", "x-amz-security-token", "x-amz-date", "x-amz-algorithm", "x-amz-credential", "x-amz-expires", "x-amz-signedHeaders", "x-amz-signature"},
    methods = {RequestMethod.GET, RequestMethod.OPTIONS, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE}
)
@RequestMapping(path = "/")
public class AccountServiceRestController {

    @Autowired
    private AccountRepository accountRepository;

    @RequestMapping(path = "/account/{accountId}", method = RequestMethod.GET)
    public ResponseEntity<Account> getAccount(@PathVariable final String accountId) {
        final Optional<Account> account = accountRepository.findById(accountId);

        if (account.isPresent()) {
            return ResponseEntity.ok(account.get());
        }

        return ResponseEntity.notFound().build();
    }

    @RequestMapping(path = "/account", method = RequestMethod.POST)
    public ResponseEntity<Account> createAccount(@RequestBody final Account account) {
        final Account savedAccount = accountRepository.save(account);

        return ResponseEntity
            .created(URI.create("/account/" + savedAccount.getAccountId() + "/"))
            .build();
    }

    @RequestMapping(path = "/account/{accountId}", method = RequestMethod.PUT)
    public ResponseEntity<Account> updateAccount(@PathVariable final String accountId, @RequestBody final Account account) {
        if (!accountRepository.existsById(accountId)) {
            return ResponseEntity.notFound().build();
        }

        account.setAccountId(accountId);

        return ResponseEntity.ok(accountRepository.save(account));
    }

    @RequestMapping(path = "/account/{accountId}", method = RequestMethod.DELETE)
    public ResponseEntity deleteAccount(@PathVariable final String accountId) {
        accountRepository.deleteById(accountId);

        return ResponseEntity
            .noContent()
            .build();
    }
}
